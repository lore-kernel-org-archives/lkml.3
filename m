Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaFYUeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:34:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57480 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbaFYUd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:33:58 -0400
Message-ID: <53AB3233.1080208@wwwdotorg.org>
Date: Wed, 25 Jun 2014 14:33:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>, thierry.reding@gmail.com,
        bhelgaas@google.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH] ARM: tegra: Migrate Apalis T30 PCIe power supply scheme
References: <67868f9464baee36eba48582d56f586ad69d3e86.1403725976.git.marcel@ziswiler.com>
In-Reply-To: <67868f9464baee36eba48582d56f586ad69d3e86.1403725976.git.marcel@ziswiler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 02:10 PM, Marcel Ziswiler wrote:
> This migration is required for continued PCIe operation after commit:
> 
> d3c7e24b84fcb62f96fa9a585a41f1829f326878

Thanks. I've applied this to Tegra's for-3.17/dt branch, where this file
was added. I also shortened the commit hash and added the commit subject
in the description, so it's more human-readable.
