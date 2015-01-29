Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbbA2Odk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:33:40 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:53771 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbbA2Odj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:33:39 -0500
Message-ID: <1422542015.32520.5.camel@x220>
Subject: Re: [PATCH 6/9] clocksource: Driver for Conexant Digicolor SoC timer
From: Paul Bolle <pebolle@tiscali.nl>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Barry.Song@csr.com, linux@rempel-privat.de, rob.herring@linaro.org,
        thierry.reding@gmail.com
Date: Thu, 29 Jan 2015 15:33:35 +0100
In-Reply-To: <20150129142639.GI19448@tarshish>
References: <54CA3044.6070501@linaro.org>
	 <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>
	 <1422536899-16609-6-git-send-email-daniel.lezcano@linaro.org>
	 <1422538656.32520.4.camel@x220> <20150129142639.GI19448@tarshish>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2015 14:33:37.0804 (UTC) FILETIME=[91BCA4C0:01D03BD0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-29 at 16:26 +0200, Baruch Siach wrote:
> > And the select for this symbol (see https://lkml.org/lkml/2015/1/26/360)
> > will be provided in a separate patch? Because this patch, by itself,
> > won't allow DIGICOLOR_TIMER to be set, will it?
> 
> Yes. Posted yesterday. See 
> http://article.gmane.org/gmane.linux.ports.arm.kernel/390166.

I see. Thanks!


Paul Bolle

