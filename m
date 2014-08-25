Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaHYK4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:56:10 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:40164 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaHYK4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:56:04 -0400
Date: Mon, 25 Aug 2014 11:55:59 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>
Cc: Harald Hoyer <harald@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: Loading initrd above 4G causes freeze on boot
Message-ID: <20140825105559.GQ29733@console-pimps.org>
References: <53E62EEF.9040801@gmail.com>
 <53F752A2.7080604@redhat.com>
 <CAPWNY8V4pfazk4Hw9qu07cAQZywC-GS7eyS+54fazXZaKMjMQw@mail.gmail.com>
 <CAPWNY8V=T=Y5uPX9J_qjdkTJRnctDs-PoTQP7LEX_cKQEn0_Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPWNY8V=T=Y5uPX9J_qjdkTJRnctDs-PoTQP7LEX_cKQEn0_Zg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Aug, at 10:19:04PM, Mantas Mikulėnas wrote:
> 
> Finally got around to testing it, and yes, your patch fixes the initrd
> boot for me.

Could you found out where the initrd gets loaded with this patch? It'll
be in the dmesg.

-- 
Matt Fleming, Intel Open Source Technology Center
