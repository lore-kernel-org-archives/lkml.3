Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbbAUR7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:59:41 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:45701 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbbAUR7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:59:31 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: Custom printk format specifier for device node
References: <1421859974-24507-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1421861843.10574.23.camel@perches.com>
	<D84576D1-27F5-44F9-83DA-347C26F593FE@antoniou-consulting.com>
Date: Wed, 21 Jan 2015 17:59:28 +0000
In-Reply-To: <D84576D1-27F5-44F9-83DA-347C26F593FE@antoniou-consulting.com>
	(Pantelis Antoniou's message of "Wed, 21 Jan 2015 19:39:44 +0200")
Message-ID: <yw1xppa8c8vz.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pantelis Antoniou <panto@antoniou-consulting.com> writes:

> Hi Joe,
>
>> On Jan 21, 2015, at 19:37 , Joe Perches <joe@perches.com> wrote:
>> 
>> On Wed, 2015-01-21 at 19:06 +0200, Pantelis Antoniou wrote:
>>> 90% of the usage of device node's full_name is printing it out
>>> in a kernel message. Preparing for the eventual delayed allocation
>>> introduce a custom printk format specifier that is both more
>>> compact and more pleasant to the eye.
>>> 
>>> For instance typical use is:
>>> 	pr_info("Frobbing node %s\n", node->full_name);
>>> 
>>> Which can be written now as:
>>> 	pr_info("Frobbing node %pO\n", node);
>> 
>> Still disliking use of %p0.
>> 
>
> Choices are limited. And it’s pO not p0.

O as in OF.  Makes sense.

-- 
Måns Rullgård
mans@mansr.com
