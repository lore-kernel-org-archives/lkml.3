Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936727Ab3DHK3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:29:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935362Ab3DHK3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:29:21 -0400
Message-ID: <51629BFF.1080204@suse.cz>
Date: Mon, 08 Apr 2013 12:29:19 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Anisse Astier <anisse@astier.eu>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        maximilian attems <max@stro.at>
Subject: Re: [PATCH 1/2] deb-pkg: split debug symbols in their own package
References: <1363946761-7449-1-git-send-email-anisse@astier.eu>
In-Reply-To: <1363946761-7449-1-git-send-email-anisse@astier.eu>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.3.2013 11:06, Anisse Astier wrote:
> This can reduce almost 3 times the size of the linux-image package,
> while keeping the debug symbols available for this particular build, in
> their own package.
> 
> This mimics the way kernels are built in debian, ubuntu, or with
> make-kpkg, and comes at the price of a small slowdown in the building of
> packages.

Shouldn't the debug subpackage only be created if CONFIG_DEBUG_INFO=y?

Thanks,
Michal
