Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab3HMS7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:59:11 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:56808 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758085Ab3HMS7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:59:10 -0400
Subject: Re: [PATCH] staging: Platform device tester - Allow removal
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130813185521.GA9483@kroah.com>
Date: Tue, 13 Aug 2013 21:59:03 +0300
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt_Coussno?= <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <DB915540-70CB-4600-BF8D-734107B1FE29@antoniou-consulting.com>
References: <1376386470-27328-1-git-send-email-panto@antoniou-consulting.com> <20130813182012.GE7740@kroah.com> <70F17005-652E-4C04-B6EC-51E16EE237C3@antoniou-consulting.com> <20130813185521.GA9483@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Just to make sure we're on the same page this is with my platform device
removal patchset applied.

Without it you get the original crash I've posted in the pdevtest patch with
the unbind method.

Regards

-- Pantelis


