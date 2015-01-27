Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbbA0P7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:59:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbbA0P7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:59:43 -0500
Message-ID: <54C7B5EC.1070706@suse.cz>
Date: Tue, 27 Jan 2015 16:59:40 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Colin King <colin.king@canonical.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: use va_end to match corresponding va_start
References: <1421068706-3689-1-git-send-email-colin.king@canonical.com>
In-Reply-To: <1421068706-3689-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-12 14:18, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Although on some systems va_end is a no-op, it is good practice
> to use va_end, especially since the manual states:
> 
> "Each invocation of va_start() must be matched by a corresponding
> invocation of va_end() in the same function."
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to kbuild.git#kconfig, thanks.

Michal

