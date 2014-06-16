Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaFPP7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:59:07 -0400
Received: from p3plsmtpa08-09.prod.phx3.secureserver.net ([173.201.193.110]:33043
	"EHLO p3plsmtpa08-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbaFPP7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:59:05 -0400
Date: Mon, 16 Jun 2014 08:58:55 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-wireless@vger.kernel.org,
        linux-nfc@ml01.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: trf7970a: Move trf7970a_init inside #ifdef
 CONFIG_PM_RUNTIME
Message-ID: <20140616155855.GA2539@animalcreek.com>
References: <1402923973-24316-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402923973-24316-1-git-send-email-geert@linux-m68k.org>
Organization: Animal Creek Technologies, Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 03:06:13PM +0200, Geert Uytterhoeven wrote:
> If CONFIG_PM_RUNTIME=n:
> 
> drivers/nfc/trf7970a.c:755: warning: ‘trf7970a_init’ defined but not used
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Mark A. Greer <mgreer@animalcreek.com>
