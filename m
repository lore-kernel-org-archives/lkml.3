Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3BDVgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:36:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39875 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab3BDVgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:36:11 -0500
Message-ID: <511029AA.1060007@zytor.com>
Date: Mon, 04 Feb 2013 13:35:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Helge Deller <deller@gmx.de>
CC: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org
Subject: Re: [PATCH] unbreak automounter support on 64-bit kernel with 32-bit
 userspace (v2)
References: <20130204193952.GA5785@p100.box>
In-Reply-To: <20130204193952.GA5785@p100.box>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 11:39 AM, Helge Deller wrote:
> 
> This suggestion is probably the best way to go, since Arm64 (and maybe others?)
> seems to have a non-working automounter. So in the long run even for other new
> upcoming architectures this inverted check seem to be the best solution, since
> it will not require them to change this #if again (unless they are 64bit only).
> 

... and even then they will generally work just fine.

	-hpa

