Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbbABJcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:32:45 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:58270 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbbABJcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:32:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] power: ab8500_fg.c:  Remove unused function
Date: Fri, 02 Jan 2015 10:32:32 +0100
Message-ID: <1460774.MbDnb649Ak@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420131892-31486-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420131892-31486-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:PFJVPlTgTM9ktpz3PUxHqzWc2BZCtPHKsrFLf07zjBaWUtJHIas
 FMQyWHgPveYdB7lIPHLw37rmHXxgKhGhJz1C662FzBb7LdfNAmvNbTu+24u/g6l5YvhGkvM
 34+zSAXUbx8SnB6WJraKPeTHXsXFQKga02P2zNjblVVSuo4JAeiM+q3orBLhI6F/2XW4jkj
 2ae5Aow44q8qqTPh4sqGQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 January 2015 18:04:52 Rickard Strandqvist wrote:
> Remove the function ab8500_fg_reinit() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Arnd Bergmann <arnd@arndb.de>
