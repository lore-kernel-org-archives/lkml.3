Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3AVI5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:57:49 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3441 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3AVI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:57:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 22 Jan 2013 00:57:40 -0800
Message-ID: <50FE55D8.6090804@nvidia.com>
Date: Tue, 22 Jan 2013 11:03:20 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Terje Bergstrom <tbergstrom@nvidia.com>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 0/8] Support for Tegra 2D hardware
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
In-Reply-To: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.01.2013 13:43, Terje Bergstrom wrote:
> This set of patches adds support for Tegra20 and Tegra30 host1x and
> 2D. It is based on linux-next-20130114. The set was regenerated with
> git format-patch -M.

I have pushed both the kernel patches and libdrm changes to
git@gitorious.org:linux-host1x/linux-host1x.git and
git@gitorious.org:linux-host1x/libdrm-host1x.git.

They're not intended to compete with any other repository - I just
wanted to have one place where people can download the kernel patches,
libdrm changes and test suite. I'll remove them once they've served
their purpose.

I'd appreciate feedback on the patches. So far the only feedback has
been from Stephen about clock changes.

Terje
