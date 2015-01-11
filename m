Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbbAKUFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 15:05:51 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34742 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbbAKUFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 15:05:49 -0500
Date: Sun, 11 Jan 2015 15:05:44 -0500
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 00/04] can: Introduce support for Kvaser USBCAN-II devices
Message-ID: <20150111200544.GA8855@linux>
References: <20141223154654.GB6460@vivalin-002>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223154654.GB6460@vivalin-002>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now since earlier v3 submission patches #1-3 got merged, this
is a new patch series expanding on patch v3 #4: support for
the USBCAN-II family.

A new series is introduced due to the extra additions suggested
by code review, which required being added in their own
self-contained patches.

Thanks,
Darwish
