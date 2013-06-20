Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030260Ab3FTLJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:09:07 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:35525 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030244Ab3FTLJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:09:06 -0400
Message-ID: <51C2E2D1.3040707@newflow.co.uk>
Date: Thu, 20 Jun 2013 12:09:05 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Unable to find JFFS2 partition ... but I know it's there !!
References: <51C2CBF1.5060900@newflow.co.uk>
In-Reply-To: <51C2CBF1.5060900@newflow.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/13 10:31, Mark Jackson wrote:
> I'm struggling to debug an issue where the kernel is unable to
> find a JFFS2 partition held in NOR flash (on CS0)

Fixed ... I finally worked out I needed to add:-

CONFIG_MTD_BLOCK
CONFIG_MTD_BLOCK2MTD

Sorry for the noise.

Mark J.
