Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3EIWN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:13:29 -0400
Received: from longford.logfs.org ([213.229.74.203]:59109 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3EIWNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:13:10 -0400
Date: Thu, 9 May 2013 16:45:33 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] mpt2sas/mpt3sas: prevent double free on error path
Message-ID: <20130509204533.GA23724@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
 <1368132193-25817-3-git-send-email-joern@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1368132193-25817-3-git-send-email-joern@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 May 2013 16:42:58 -0400, Joern Engel wrote:
> Subject: [PATCH] mpt2sas/mpt3sas: prevent double free on error path

The two mtp[23]sas patches shouldn't have been in here.  Sorry about
the noise!

Jörn

--
Das Aufregende am Schreiben ist es, eine Ordnung zu schaffen, wo
vorher keine existiert hat.
-- Doris Lessing
