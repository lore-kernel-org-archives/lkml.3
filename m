Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaLVLvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:51:32 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:58423 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbaLVLv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:51:29 -0500
Message-ID: <549805AF.2080604@ahsoftware.de>
Date: Mon, 22 Dec 2014 12:51:11 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] CodingStyle: remove what nowadays might be considered
 polemic
References: <1418996188-2908-1-git-send-email-holler@ahsoftware.de>	 <54969F9A.80301@ahsoftware.de> <1419181792.4200.2.camel@perches.com>
In-Reply-To: <1419181792.4200.2.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.12.2014 um 18:09 schrieb Joe Perches:
> On Sun, 2014-12-21 at 11:23 +0100, Alexander Holler wrote:
>> Am 19.12.2014 um 14:36 schrieb Alexander Holler:
>>> In times where things like checkpatch do exist and are mandated to be used,
>>> it would be easy to warn if too many levels of indentation are used (e.g.
>>> by counting leading tabs).
>
> checkpatch already does that looking for 6+ leading
> tabs then any statement that increases indentation.

Oh, nice. I didn't know that.

>> I've heared that wrong argument that a maximum line length
>> of 80 chars helps in regard to keep the levels of intendation low once
>> too often.
>
> I believe that argument correct.
>
> helps is not a mandate.
>
> The idea is that code that start far from the left
> (for some definition of far) is a signal that code
> could be refactored into more discrete chunks.

I think people just make variable and function names even more cryptic 
(shorter) in order to let them fit into the remaining free space. That 
seems to be easier for most than to refactor their code.

Regards,

Alexander Holler
