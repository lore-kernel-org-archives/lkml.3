Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaEETlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:41:46 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:59977 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaEETln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:41:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140505193616.GR11231@htj.dyndns.org>
References: <cover.1398797954.git.shuah.kh@samsung.com>
	<6cb20ce23f540c883e60e6ce71302042b034c4aa.1398797955.git.shuah.kh@samsung.com>
	<20140501145337.GC31611@htj.dyndns.org>
	<5367E39E.7090401@samsung.com>
	<20140505192633.GQ11231@htj.dyndns.org>
	<CAGoCfiwoFipx79tx6Jkgx5nfU_K9qXdfGe25kzrNb6Jwka0H7A@mail.gmail.com>
	<20140505193616.GR11231@htj.dyndns.org>
Date: Mon, 5 May 2014 15:41:43 -0400
Message-ID: <CAGoCfix3DB3cNy3Zk74nQzVw6gxCBWq_c-dRFHArLRiK_yrWUQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers/base: add managed token devres interfaces
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tejun Heo <tj@kernel.org>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>, olebowle@gmx.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 3:36 PM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, May 05, 2014 at 03:30:34PM -0400, Devin Heitmueller wrote:
>> On Mon, May 5, 2014 at 3:26 PM, Tejun Heo <tj@kernel.org> wrote:
>> > As such, please consider the patches nacked and try to find someone
>> > who can shepherd the code.  Mauro, can you help out here?
>>
>> We actually discussed this proposal at length at the media summit last
>> week.  The patches are being pulled pending further internal review
>
> "being pulled into a tree" or "being pulled for more work"?

Sorry, I wasn't clear.  They are being pulled for more work.  After
discussion with the rest of the linux-media developers, it was
determined that the patches don't cover all the use cases and the
patch submission was premature.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
