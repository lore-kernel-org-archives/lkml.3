Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3AXKgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:36:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab3AXKgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:36:40 -0500
Message-ID: <51010EAF.4090704@suse.cz>
Date: Thu, 24 Jan 2013 11:36:31 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tiana Rakotovao Andriamahefa <rkmahefa@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: qt3 and ptrdiff_t build error
References: <20130115231251.GA6100@rak.local> <20130116063156.GA28910@pryan.ekaia.org> <20130116122610.GA7613@rak.local>
In-Reply-To: <20130116122610.GA7613@rak.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.1.2013 13:26, Tiana Rakotovao Andriamahefa wrote:
> I have checked it and found that the error was effectively fixed in the last
> maintained upload of Qt3 in 2011. However, the correction is not yet in Wheezy
> (Debian testing) which I have used for more than a year. It might be
> included there one day!
> This is the case of Debian, but not all distros.

OK. And it is dead upstream. So I'll apply your patch. Could you please
resend it? I deleted the email already.

Thanks,
Michal
