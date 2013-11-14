Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3KNNmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 08:42:47 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57352 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3KNNmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 08:42:42 -0500
Date: Thu, 14 Nov 2013 13:42:18 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.ernst@linux.intel.com,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 1/3] ipc: Added platform data structure
Message-ID: <20131114134218.638373ef@alan.etchedpixels.co.uk>
In-Reply-To: <1384373671-12814-2-git-send-email-david.a.cohen@linux.intel.com>
References: <1384373671-12814-1-git-send-email-david.a.cohen@linux.intel.com>
	<1384373671-12814-2-git-send-email-david.a.cohen@linux.intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 12:14:29 -0800
David Cohen <david.a.cohen@linux.intel.com> wrote:

> From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> 
> Since the same ipc driver can be used by many platforms, using
> macros for defining ipc_base and i2c_base addresses is not
> a scalable approach. So added a platform data structure to pass
> this information.
> 
> Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> Cc: David Cohen <david.a.cohen@linux.intel.com>

Acked-by: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
