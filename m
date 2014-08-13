Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaHMVho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 17:37:44 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:60351 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaHMVhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 17:37:43 -0400
MIME-Version: 1.0
In-Reply-To: <53EA4357.5020602@infradead.org>
References: <1407769416-13818-1-git-send-email-bobby.prani@gmail.com>
 <alpine.DEB.2.11.1408111222340.14298@gentwo.org> <53EA4357.5020602@infradead.org>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 13 Aug 2014 17:37:10 -0400
Message-ID: <CAJhHMCDRp1OF_EpmT2ut9HVTu40EoF0WXbxkhm8OqWUY5tov0Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] doc: this_cpu_ops.txt: Update description of this_cpu_ops
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Lameter <cl@linux.com>,
        "open list:DOCUMENTATION <linux-doc@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 12:39 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 08/11/14 10:22, Christoph Lameter wrote:
>> On Mon, 11 Aug 2014, Pranith Kumar wrote:
>>
>>> Update the description for per cpu operations to clarify use cases
>>> of this_cpu operations and add considerations for remote access.
>>
>> Looks fine.
>
> Applied.  Thanks.
>

Hi Randy, I just saw that this commit has been applied with the
Changelog as the subject. Is it too late to correct that? The subject
should be:

"doc: this_cpu_ops.txt: Update description of this_cpu_ops"

-- 
Pranith
