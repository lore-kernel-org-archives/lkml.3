Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab3CUU1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:27:42 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:53649 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756Ab3CUU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:27:41 -0400
Message-ID: <1363897656.1390.155.camel@x61.thuisdomein>
Subject: Re: [PATCH] video: nuc900fb: remove "config FB_NUC900_DEBUG"
From: Paul Bolle <pebolle@tiscali.nl>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 21:27:36 +0100
In-Reply-To: <1363897258.1390.153.camel@x61.thuisdomein>
References: <1363897258.1390.153.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 20:27:39.0404 (UTC) FILETIME=[883B54C0:01CE2672]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 21:20 +0100, Paul Bolle wrote:
> When the NUC900 LCD Controller Driver got added (in v3.4) a Kconfig
> entry for FB_NUC900_DEBUG got added too. It has never been used. It
> appears that its users were dropped during review. Anyhow, this entry
> can be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Please s/v3.4/v2.6.34/.


Paul Bolle

