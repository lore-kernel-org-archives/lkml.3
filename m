Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaFKI0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:26:06 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:65312 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbaFKI0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:26:04 -0400
Message-ID: <1402475161.3798.49.camel@x220>
Subject: ARC: CONFIG_ARC_MMU_V4
From: Paul Bolle <pebolle@tiscali.nl>
To: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 11 Jun 2014 10:26:01 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2014 08:26:01.0467 (UTC) FILETIME=[C74CB4B0:01CF854E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

Commit ef680cdc2437 ("ARC: Disable caches in early boot if so
configured") landed in linux-next yesterday (ie, next-20140610). It
includes two optional tests for CONFIG_ARC_MMU_V4. There's no Kconfig
symbol ARC_MMU_V4 in linux-next.

I assume you've got that symbol queued somewhere. Is that correct?

Thanks,


Paul Bolle

