Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbaGWV03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:26:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58412 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933453AbaGWV02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:26:28 -0400
Date: Wed, 23 Jul 2014 22:26:01 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: linux-kernel@vger.kernel.org, linux@openrisc.net, jonas@southpole.se
Subject: Re: [PATCH 1/6] openrisc: add Kconfig for l.lwa and l.swa atomic
 instructions
Message-ID: <20140723222601.51a8b788@alan.etchedpixels.co.uk>
In-Reply-To: <1406150296-13308-2-git-send-email-stefan.kristiansson@saunalahti.fi>
References: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
	<1406150296-13308-2-git-send-email-stefan.kristiansson@saunalahti.fi>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config OPENRISC_HAVE_INST_LWA_SWA
> +	bool "Have instruction l.lwa and l.swa"
> +	help
> +	  Select this if your implementation have l.lwa and l.swa atomic
> +	  instructions.
> +
>  endmenu

Please do everyone a favour - sort all these out at runtime, add an
architectural feature bits ROM address or catch the traps and use the
alterntatives logic or something.

Alan

