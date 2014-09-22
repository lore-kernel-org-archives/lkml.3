Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaIVXzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 19:55:54 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49901 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbaIVXzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 19:55:52 -0400
Date: Tue, 23 Sep 2014 09:56:53 +1000
From: Angus Gibson <angus@agibson.me>
To: mark.einon@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [RFC PATCH linux-next] et131x: Promote staging et131x driver to
 drivers/net
Message-ID: <20140922235653.GA17359@angus-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411421283-25073-1-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config NET_VENDOR_AGERE
> +	bool "Agere devices"
> +	default y
> +	depends on PCI
> +	---help---
> +	  If you have a network (Ethernet) card belonging to this class, say =
> Y
> +	  and read the Ethernet-HOWTO, available from
> +	  <http://www.tldp.org/docs.html#howto>.
> +
> +	  Note that the answer to this question doesn't directly affect the
> +	  kernel: saying N will just cause the configurator to skip all
> +	  the questions about Atheros devices. If you say Y, you will be aske=
should this be "Agere devices" instead?
> d
> +	  for your specific card in the following questions.
