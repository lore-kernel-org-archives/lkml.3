Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaJPP04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:26:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56607 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaJPP0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:26:52 -0400
Message-ID: <543FE3CA.3090209@wwwdotorg.org>
Date: Thu, 16 Oct 2014 09:27:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?windows-1252?Q?Antoine_T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH v2 45/53] dmaengine: bcm2835: Declare slave capabilities
 for the generic code
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com> <1413454672-27400-46-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1413454672-27400-46-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 04:17 AM, Maxime Ripard wrote:
> Now that the generic slave caps code can make use of the device assigned
> capabilities, instead of relying on a callback to be implemented.
>
> Make use of this code.

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

