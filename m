Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbaFSWqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:46:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35244 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757998AbaFSWqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:46:18 -0400
Message-ID: <53A36831.8090901@zytor.com>
Date: Thu, 19 Jun 2014 15:46:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Josh Boyer <jwboyer@fedoraproject.org>
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86,vdso: Create .build-id links for unstripped vdso
 files
References: <cover.1403129369.git.luto@amacapital.net> <26fa44a597716445c134d21194170c292d46a421.1403129369.git.luto@amacapital.net>
In-Reply-To: <26fa44a597716445c134d21194170c292d46a421.1403129369.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 03:59 PM, Andy Lutomirski wrote:
> 
> This may break make vdso_install with binutils before 2.17.50.0.17.
> On the other hand, make vdso_install was probably never useful with
> earlier binutils, since the installed files are AFAIK completely
> useless without build-id.
> 

How does it fail?

	-hpa


