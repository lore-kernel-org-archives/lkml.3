Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaLPRmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 12:42:09 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63830 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaLPRmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 12:42:08 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <549068A4.3020702@hurleysoftware.com>
References: <1418681761-3709-1-git-send-email-imre.deak@intel.com>
	<1418681761-3709-3-git-send-email-imre.deak@intel.com>
	<20141216075300.GI2711@phenom.ffwll.local>
	<1418725405.3185.31.camel@ideak-mobl>
	<54902AA1.7080301@hurleysoftware.com>
	<1418740692.7338.33.camel@intelbox>
	<5490491E.70102@hurleysoftware.com>
	<1418746939.7338.56.camel@intelbox>
	<549068A4.3020702@hurleysoftware.com>
Date: Tue, 16 Dec 2014 18:42:06 +0100
Message-ID: <CAKMK7uHfimdJVTfueHkCO61b_+rwcEPo90FxZodEMpSX-B6sLw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] vt: fix console lock vs. kernfs s_active lock order
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Imre Deak <imre.deak@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 6:15 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 12/16/2014 11:22 AM, Imre Deak wrote:
>> On Tue, 2014-12-16 at 10:00 -0500, Peter Hurley wrote:
>>> Fine. Just another expedient fix piled on top of other expedient fixes
>>> that go back past 3.9 with no end in sight.
>>
>> I'm also happy to look into narrowing down the scope of console_lock in
>> fbdev/fbcon as was suggested. But doing that as a follow-up to this
>> change still makes sense to me since it will take more time and have the
>> risk of regressions that are not related to what this change fixes.
>
> I apologize for my tone. I'm not blaming you for the current situation,
> nor is it your responsibility to go fix vt/fbcon/fbdev driver stack
> inversion. I'm just trying to bring some awareness of the larger scope,
> so that collectively we take action and resolve the underlying problems.

Yeah I guess I should tune down my NACK to a Grumpy-if-merged-by too.
We have a lot of nonoptimal solutions at hand here :(
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
