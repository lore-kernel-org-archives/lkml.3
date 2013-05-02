Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab3EBR6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:58:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761175Ab3EBR56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:57:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH, RFC 22/22] radio-si4713: depend on SND_SOC
Date: Thu, 2 May 2013 19:57:33 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-23-git-send-email-arnd@arndb.de> <5182A44E.7080701@redhat.com>
In-Reply-To: <5182A44E.7080701@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305021957.33657.arnd@arndb.de>
X-Provags-ID: V02:K0:LhXOkH8Tom3RGYrT1gouV02diOdAXTwdneXvVMGge5e
 ibn0eDKE0hl3CKtqpRrwcUhLuZ2VUlxP1EFW7E/ioguYm79WVD
 5SC2PxrvkWYH1Q7jlkpqQAkB/EDnd9zP1dVhn8N2p5fV3+h845
 +QfnBzgCNE7CWRpC4zVZmvks+e7HLbXvM354h+BtMlLp+6vlqz
 c678seymbFCg3sutA5fY9x9dNR293OuSm4gpdmadoiZDPXUZP5
 SZj1Y9EGfXr7YJyDG6HccuGCl4/ZIUZXWpszxYlUektYtzkKfE
 NwF71eScFNn+scASUE6SAClaxSTTQ2HXUl9vIc6N3FcvUeOo6W
 Ne55Tuy4v1kwCcSZPd+Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Mauro Carvalho Chehab wrote:
> Do you prefer to send it via your tree or via mine? Either way works for me.
> 
> If you're willing to send it via your tree:
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

I'd prefer your tree, because the patch does not apply on 3.9.

	Arnd
