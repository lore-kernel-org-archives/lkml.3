Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab3CUO3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:29:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65075 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab3CUO3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:29:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] stallion: final cleanup
Date: Thu, 21 Mar 2013 14:29:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <1363871896.1390.138.camel@x61.thuisdomein>
In-Reply-To: <1363871896.1390.138.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303211429.29502.arnd@arndb.de>
X-Provags-ID: V02:K0:WM9BhNxp9KDymj17ekzqUJLpLN1q21NDKHHyN9VCMJK
 22c8aoAxd842JnLZzimmjkj+BVQGEWj/ijr0E1ueB+y2y5Xbwg
 414VgabXcuCzLM3sohyhD6MAT/1r6crUlVTHpscO3Q2YiY623H
 7nQ9nfptoVdrkY/C9FU3F8JfHFWhpXeG8VMVmHEJryv48fkP34
 t3GI83e13603At6HzFCc9dOKpwuROSP8goqIU5Ac0sr3jOt248
 /7otyu4c1KfqbD5VU60wS5QJyhx6849yrUAfLQMefbRdy0TdzN
 hkQdD5Dkg0QCQtX9eLlTb3lQwLPDOzQsaTrZd8du7HiWWt/Gd+
 FR7FkSGXFDThvIl62THk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 March 2013, Paul Bolle wrote:
> Support for the Stallion multiport serial drivers was removed in v3.1.
> Clean up their last references in the tree: mainly an outdated Kconfig
> entry and unneeded documentation.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Arnd Bergmann <arnd@arndb.de>
