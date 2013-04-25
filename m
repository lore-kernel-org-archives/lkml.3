Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab3DYIUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:20:48 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:53125 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756045Ab3DYIUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:20:46 -0400
Message-ID: <1366878044.1349.19.camel@x61.thuisdomein>
Subject: Re: [PATCH 3.8-stable] ARM: 7690/1: mm: fix CONFIG_LPAE typos
From: Paul Bolle <pebolle@tiscali.nl>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Date: Thu, 25 Apr 2013 10:20:44 +0200
In-Reply-To: <000001ce418b$320597d0$9610c770$%choi@samsung.com>
References: <004801ce33e4$0a2ffc00$1e8ff400$%choi@samsung.com>
	 <000001ce418b$320597d0$9610c770$%choi@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Apr 2013 08:20:44.0450 (UTC) FILETIME=[C826C020:01CE418D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 17:02 +0900, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.8-stable tree, should we apply
> it?

That would be only the setup.c chunk. That fixes a typo introduced in
v3.4 (see commit e5ab85800820edd907d3f43f285e1232f84d5a41
("ARM: 7382/1: mm: truncate memory banks to fit in 4GB space for classic
MMU")). So, if that chunk is deemed appropriate for stable, you could
consider the v3.4.y longterm tree too.

(The typo in head.S was introduced in v3.9-rc2.)


Paul Bolle

