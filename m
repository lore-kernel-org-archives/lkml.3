Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbaFRCzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 22:55:04 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38228 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242AbaFRCzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 22:55:02 -0400
Message-ID: <53A0FF81.6090405@gmail.com>
Date: Wed, 18 Jun 2014 08:24:57 +0530
From: Anil Shashikumar Belur <askb23@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpdd-discuss@lists.01.org" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH v6 7/8] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
References: <1402983839-3549-1-git-send-email-askb23@gmail.com> <1402983839-3549-8-git-send-email-askb23@gmail.com> <CFC5C64E.ABDAF%andreas.dilger@intel.com>
In-Reply-To: <CFC5C64E.ABDAF%andreas.dilger@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Should be an empty line between variable declarations and code.

Hi Andreas, not sure if you are referring to the same patch as there is
already an empty line present.

 823                                 loff_t size = cl_isize_read(inode);
 824                                 loff_t cur_index = start >>
PAGE_CACHE_SHIFT;
 825                                 loff_t size_index = ((size - 1) >>
PAGE_CACHE_SHIFT);
 826
 827                                 if ((size == 0 && cur_index != 0) ||

Cheers,
Anil
