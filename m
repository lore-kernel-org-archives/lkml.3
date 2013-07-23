Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3GWMDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:03:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58493 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab3GWMDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:03:17 -0400
Message-ID: <51EE70D4.1030706@zytor.com>
Date: Tue, 23 Jul 2013 05:02:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Fix early microcode loading on AMD
References: <20130723135853.579c3cd5@googlemail.com>
In-Reply-To: <20130723135853.579c3cd5@googlemail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav, do you agree with these patches?  (This one and the errata
check?)  If so I will queue them up in x86/urgent.

	-hpa

