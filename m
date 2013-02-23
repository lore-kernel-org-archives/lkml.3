Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab3BWWcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 17:32:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49993 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759013Ab3BWWcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 17:32:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [patch 2/2] arm: Wire up kcmp syscall
Date: Sat, 23 Feb 2013 22:31:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Russell King <linux@arm.linux.org.uk>, xemul@parallels.com,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com,
        akpm@linux-foundation.org,
        Alexander Kartashov <alekskartashov@parallels.com>
References: <20130219064800.719149796@openvz.org> <20130219065210.148067470@openvz.org> <20130219070703.GC20312@moon>
In-Reply-To: <20130219070703.GC20312@moon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302232231.45972.arnd@arndb.de>
X-Provags-ID: V02:K0:2s7ZqQmx19DllXCPJ94rxO3uoVi52I5oFJgyCREJKIw
 DLeB/CCrKhk7QSzFe92/zd3y+HLTT7R77Eb9YWtIPGpdA62qED
 5TIxrU3SpZFPHu3wCQlZIsDnMXwEALF2fDkWmxCt0v625zYkna
 LS+/ySMqrxg20nEQybhxY9wK4C2O73gMw0h1iV3LQCwYCenl9X
 IZ3WsBA2G+65qAIraOFCGRfadfVACZ31MVGuSssgcWYVfhT6P5
 5COaRBuBMOh9LnM69uBhBa2n25TjW0/s1cA05COp2RL8rhE5PD
 0IuwVjc4D4RmoITzp59EuP9xOv39UhKDFf+RlFInNt6uwXd2I+
 87+OLn+R4VIqKSRi0ZIk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2013, Cyrill Gorcunov wrote:
> From: Alexander Kartashov <alekskartashov@parallels.com>
> Subject: arm: Wire up kcmp syscall
> 
> Signed-off-by: Alexander Kartashov <alekskartashov@parallels.com>
> Cc: Russell King <linux@arm.linux.org.uk>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Looks uncontroversial since the number is already reserved and
there is a cond_syscall() line, which means it does not
even depend on patch 1.

Russell, are you picking this one up?
