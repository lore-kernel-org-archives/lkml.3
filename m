Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3KXQoo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 11:44:44 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56553 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3KXQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 11:44:37 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX183YWiNoBbjnUGHzo1vPEWSzSkSAeNxyg0=
Date: Sun, 24 Nov 2013 11:44:24 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: orion5x: Fix typo in device_type property of phy
 node
Message-ID: <20131124164424.GE29241@titan.lakedaemon.net>
References: <1384440788-3529-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384440788-3529-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 02:53:08PM +0000, Srinivas Kandagatla wrote:
> This patch fixes a typo for device_type property of phy node.
> This can work as of today but once a checks are added in generic code
> this typo will stop phy from working.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
>  .../dts/orion5x-lacie-ethernet-disk-mini-v2.dts    |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied to mvebu/dt with Andrew's Ack.

thx,

Jason.
