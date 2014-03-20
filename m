Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbaCTU6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:58:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51673 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759719AbaCTU6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:58:33 -0400
Date: Thu, 20 Mar 2014 16:58:25 -0400 (EDT)
Message-Id: <20140320.165825.2258647784698720017.davem@davemloft.net>
To: benchan@chromium.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oliver@neukum.org, gregkh@linuxfoundation.org,
        bjorn@mork.no, gsuarez@smithmicro.com
Subject: Re: [PATCH net-next v4 0/2] adjust MTU as indicated by MBIM
 extended functional descriptor
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395262806-19237-1-git-send-email-benchan@chromium.org>
References: <1395262806-19237-1-git-send-email-benchan@chromium.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Mar 2014 13:58:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Chan <benchan@chromium.org>
Date: Wed, 19 Mar 2014 14:00:04 -0700

> The MBIM extended functional descriptor, defined in "Universal Serial Bus
> Communications Class Subclass Specification for Mobile Broadband Interface
> Model, Revision 1.0, Errata-1" by USB-IF, indicates the operator preferred MTU
> value via a wMTU field.
> 
> This patch set ensures that the initial MTU value set by cdc_ncm on a MBIM net
> device does not exceed the wMTU value, provided the MBIM device exposes a MBIM
> extended functional descriptor.
> 
> * Changelog
> v2: Fixed a le16_to_cpu conversion issue in patch 2/2 pointed out by
>     Bjørn Mork <bjorn@mork.no>
> v3: No code changes. Resubmitted to include patch 1/2 as suggested by
>     David Miller <davem@davemloft.net>
> v4: No code changes. Resubmitted as suggested by David Miller:
>     - Added a summary of the patch set
>     - Carried the ACK from Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     - Added a specified the tree (net-next) to apply the patch set to

Series applied to net-next, thanks Ben.
