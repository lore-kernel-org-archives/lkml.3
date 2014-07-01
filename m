Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbaGALgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 07:36:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:45787 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143AbaGALgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 07:36:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Zhenghui Zhou <zhouzhenghui@gmail.com>
Subject: Re: [PATCH v5 7/9] of: spi: Export single device registration method and accessors
Date: Tue, 1 Jul 2014 11:27:07 +0000 (UTC)
Message-ID: <loom.20140701T111815-823@post.gmane.org>
References: <1401281193-27146-1-git-send-email-pantelis.antoniou@konsulko.com> <1401281193-27146-8-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 198.23.203.150 (Mozilla/5.0 (Windows NT 6.1; rv:30.0) Gecko/20100101 Firefox/30.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pantelis Antoniou <pantelis.antoniou <at> konsulko.com> writes:

> +static struct spi_device *
> +of_register_spi_device(struct spi_master *master, struct device_node *node)
> +{
> +	struct spi_device *spi;
> +	struct device_node *nc;

Should there be:

of_register_spi_device(struct spi_master *master, struct device_node *nc)
{
	struct spi_device *spi;




