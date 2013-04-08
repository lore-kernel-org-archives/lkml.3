Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936828Ab3DHK4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:56:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935424Ab3DHK4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:56:17 -0400
Date: Mon, 8 Apr 2013 07:56:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Prabhakar lad <prabhakar.csengg@gmail.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 0/2] ARM: davinci: dm355: add support for vpbe
 display
Message-ID: <20130408075606.5a59d32c@redhat.com>
In-Reply-To: <51629DA8.3040806@ti.com>
References: <1365413215-3632-1-git-send-email-prabhakar.csengg@gmail.com>
	<51629DA8.3040806@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

Em Mon, 8 Apr 2013 16:06:24 +0530
Sekhar Nori <nsekhar@ti.com> escreveu:

> On 4/8/2013 2:56 PM, Prabhakar lad wrote:
> > From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > 
> > This patch series enables VPBE display driver on DM355.
> 
> These (this and the DM365 one) patches look good to me. I need to get an
> immutable branch from Mauro where dependencies are queued and then I can
> generate a pull request for these for ARM SoC.

Are you mean a branch at the media development tree for you to sent
pull requests for me? If so, just use the "master" branch at the media
tree:
	http://git.linuxtv.org/media_tree.git

The master branch there is never rebased. I'll likely start to have
topic branches on the next Kernel cycle, also at the same tree.

Regards,
Mauro
