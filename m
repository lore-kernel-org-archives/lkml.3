Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935403Ab3DHKgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:36:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38296 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934908Ab3DHKgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:36:37 -0400
Message-ID: <51629DA8.3040806@ti.com>
Date: Mon, 8 Apr 2013 16:06:24 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v8 0/2] ARM: davinci: dm355: add support for vpbe display
References: <1365413215-3632-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1365413215-3632-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/8/2013 2:56 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> This patch series enables VPBE display driver on DM355.

These (this and the DM365 one) patches look good to me. I need to get an
immutable branch from Mauro where dependencies are queued and then I can
generate a pull request for these for ARM SoC.

Thanks,
Sekhar

