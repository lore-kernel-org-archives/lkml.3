Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbbAVPzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:55:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64074 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752008AbbAVPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:55:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Shaohua Li <shaohua.li@intel.com>,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] int to bool conversion
Date: Thu, 22 Jan 2015 17:18:15 +0100
Message-ID: <1659960.ohcxabvmYi@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150122084941.GA14651@sloth>
References: <20150122084941.GA14651@sloth>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 22, 2015 09:49:41 AM Quentin Lambert wrote:
> These patches convert local variables from int to bool when relevant.

And what exactly is the need for that?  Does that fix any functional problems?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
