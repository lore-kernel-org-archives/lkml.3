Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3F0RVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:21:39 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:62994 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3F0RVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:21:38 -0400
MIME-Version: 1.0
In-Reply-To: <C2B6127F-2C6D-49ED-9E45-5FEE9CC1BCE4@theobroma-systems.com>
References: <61455.62.178.124.14.1371832855.squirrel@mail.theobroma-systems.com>
	<CAOMZO5CyK9S-Wmm+ihBeMCaDBJyxBb-vSQjzZiKrmz74mb=vDw@mail.gmail.com>
	<C2B6127F-2C6D-49ED-9E45-5FEE9CC1BCE4@theobroma-systems.com>
Date: Thu, 27 Jun 2013 14:21:37 -0300
Message-ID: <CAOMZO5Cs9KfWGL-4HTF+rntzg1BE6L84vO67DL7qA+_eFJji-g@mail.gmail.com>
Subject: Re: [PATCH] net: fec: Fix multicast list setup in fec_restart().
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Christoph_M=C3=BCllner?= 
	<christoph.muellner@theobroma-systems.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <fabio.estevam@freescale.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 2:14 PM, Christoph Müllner
<christoph.muellner@theobroma-systems.com> wrote:

> Is updated in the attached patch.
> Thank you for the feedback!

Looks good.  Some suggestions:

- Mark the patch as the second version:
Subject: [PATCH v2] net: fec: Fix multicast list setup in fec_restart().

- Add a comment below the --- line explaining what you changed in v2.

Something like:

---
Changes since v1:
- Adapt the comment to the code change

- Then re-send it via git send-email to the list instead of sending it
via attachment.

Thanks,

Fabio Estevam
