Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaJFJiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:38:08 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:54345 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbaJFJiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:38:05 -0400
Message-ID: <1412588282.4054.51.camel@x220>
Subject: Re: [PATCH 3/4] [media] Remove optional dependency on PLAT_S5P
From: Paul Bolle <pebolle@tiscali.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valentin Rothberg <valentinrothberg@gmail.com>
Date: Mon, 06 Oct 2014 11:38:02 +0200
In-Reply-To: <54326223.3050201@samsung.com>
References: <1412586626.4054.42.camel@x220> <4788945.SoI4OqN9Zu@wuerfel>
	 <54326223.3050201@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2014 09:38:03.0323 (UTC) FILETIME=[39A858B0:01CFE149]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 11:34 +0200, Sylwester Nawrocki wrote:
> On 06/10/14 11:26, Arnd Bergmann wrote:
> > 
> > Does S5PV210 have this device?
> 
> Yes, it does. Indeed, in all patches in this series we should
> have replaced PLAT_S5P with ARCH_S5PV210.

If somebody would actually do that, that would be great. I lost patience
waiting for a patch that did that. So I submitted these cleanup patches
that basically change nothing.


Paul Bolle

