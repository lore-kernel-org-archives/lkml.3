Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbaFRCym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 22:54:42 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63087 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242AbaFRCyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 22:54:41 -0400
Message-ID: <53A0FF6D.6050806@gmail.com>
Date: Wed, 18 Jun 2014 08:24:37 +0530
From: Anil Shashikumar Belur <askb23@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpdd-discuss@lists.01.org" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH v6 3/8] staging: lustre: lclient: lcommon_misc.c fixing
 coding style issues
References: <1402983839-3549-1-git-send-email-askb23@gmail.com> <1402983839-3549-4-git-send-email-askb23@gmail.com> <CFC5C5CA.ABDA9%andreas.dilger@intel.com>
In-Reply-To: <CFC5C5CA.ABDA9%andreas.dilger@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you are using min_t(__u32, ...) then there is no need for the
(__u32) cast of LOV_MAX_STRIPE_COUNT, since that is the whole point of
min_t() that the cast is done internally.

Agreed, it makes sense not to cast twice when using min_t().
