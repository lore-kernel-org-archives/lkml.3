Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965993AbaFTIwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:52:01 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65324 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933833AbaFTIv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:51:59 -0400
Message-ID: <53A3F62A.4040006@gmail.com>
Date: Fri, 20 Jun 2014 14:21:54 +0530
From: Tushar Behera <trblinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
CC: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 0/3] Remove devm_request_and_ioremap()
References: <1403203741-5113-1-git-send-email-wsa@the-dreams.de> <000c01cf8c30$613759d0$23a60d70$%han@samsung.com> <20140620025957.GA27387@kroah.com> <20140620084506.GA2762@katana>
In-Reply-To: <20140620084506.GA2762@katana>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/20/2014 02:15 PM, Wolfram Sang wrote:
> On Thu, Jun 19, 2014 at 07:59:57PM -0700, 'Greg Kroah-Hartman'
> wrote:
>> On Fri, Jun 20, 2014 at 11:36:03AM +0900, Jingoo Han wrote:
>>> On Friday, June 20, 2014 3:49 AM, Wolfram Sang wrote:
>>>> 
>>>> Pretty much a year ago, Tushar cleaned up a lot of deprecated
>>>> uses of devm_request_and_ioremap, yet some remains are still
>>>> left. Remove the last two users, and let the function rest in
>>>> peace. I'd suggest that this series is picked up as a whole
>>>> to have that case finally closed. Greg? Are you interested in
>>>> picking it up?
>>> 
>>> (+cc Greg Kroah-Hartman)
>>> 
>>> I already sent the same patch as one single patch to Greg
>>> Kroah-Hartman. [1] Also, it was accepted by Greg Kroah-Hartman.
>>> [2] Thank you.
>>> 
>>> [1] https://lkml.org/lkml/2014/6/11/26 [2]
>>> https://lkml.org/lkml/2014/6/11/649
>> 
>> Yeah, I'll go apply that right now while I'm remembering it :)
> 
> For the patch above:
> 
> Reviewed-by: Wolfram Sang <wsa@the-dreams.de>
> 

If it is still not late,

Acked-by: Tushar Behera <trblinux@gmail.com>

- -- 
Tushar Behera
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTo/YpAAoJELqclMPPkq4NOsIIAIkN+lOgWTIo3IBw7oQ9yO76
Hjn6fR2kjWOdrXrTdW3KQRzElw8hMKdPF5++GkgAkreoLSxRBLnyHdGc0jPdmxXw
gIu4O0WNQYRKYN+fkHPkl/5z10SNmZrnwcq37FK8EMCqpph7JywYOu5WyNVjMKOh
gTJ9zME+iCAzE+KlzBr7pRLySkFvgtITqBRT/lsRmGGpjH+kphSmYuY2kvz2VVLI
DE6Zy8kOyZEEDwDsm62qhoZNtzKcGoZgSqNFKU8fM9duonRhAwUQKImUnKB1H1CD
FQcmZI/4WA/6OLypUSBj/AIciK1MW/Gu6IpILjNVwQA/q3CKEaUkiHf+2HNVohU=
=FBDs
-----END PGP SIGNATURE-----
