Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab3CATFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:05:06 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33037 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3CATFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:05:04 -0500
Date: Fri, 1 Mar 2013 11:05:00 -0800
From: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
To: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ingo Molnar (mingo@kernel.org)" <mingo@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        "trenn@suse.com" <trenn@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [stable 3.0 v2] x86/apic: Work around boot failure on HP
 ProLiant DL980 G7 Server systems
Message-ID: <20130301190500.GB15096@kroah.com>
References: <92645B27BF79D04FBD2B0F8494FFD0F9C30940@G2W2436.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92645B27BF79D04FBD2B0F8494FFD0F9C30940@G2W2436.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 11:07:26AM +0000, Zhang, Lin-Bao (Linux Kernel R&D) wrote:
> Hi Greg,
> 
> This patch is specially for 3.0 by integrating upstream commit cb214ede7657db458fd0b2a25ea0b28dbf900ebc 
> and ea0dcf903e7d76aa5d483d876215fedcfdfe140f .
> I fixed patch format warning and re-send it as v2. Thanks . 

Now applied, thanks.

greg k-h
