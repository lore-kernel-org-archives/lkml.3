Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaACPDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:03:41 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33476 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaACPDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:03:40 -0500
Date: Fri, 3 Jan 2014 15:03:24 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: eric.ernst@linux.intel.com
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriel Touzeau <gabrielx.touzeau@intel.com>,
        Yann Puech <yann.puech@intel.com>,
        Jeremy Compostella <jeremy.compostella@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH 1/1] watchdog: Adding Merrifield watchdog driver support
Message-ID: <20140103150324.3f36cb50@alan.etchedpixels.co.uk>
In-Reply-To: <1388710602-18513-1-git-send-email-eric.ernst@linux.intel.com>
References: <1388710602-18513-1-git-send-email-eric.ernst@linux.intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Jan 2014 16:56:42 -0800
eric.ernst@linux.intel.com wrote:

> From: Gabriel Touzeau <gabrielx.touzeau@intel.com>
> 
> Added Merrifield watchdog driver support.
> 
> Based on initial implementation from prior Intel SCU-based platforms, this
> driver has several changes specific to the Tangier SoC / Merrifield platform.

We have a watchdog driver layer now. Any new driver should be using that.
It deals with a lot of the work for you so you'll just need the actual
methods doing the work. It also registers both the legacy device and new
style watchdog nodes as appropriate so you can have multiple watchdogs on
a system.

Look at watchdog_core.c and watchdog_dev.c and the various things that
use it.

Alan
