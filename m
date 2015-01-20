Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbbATSUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:20:39 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:57439 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbbATSUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:20:37 -0500
Date: Tue, 20 Jan 2015 13:20:36 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, Darren Hart <dvhart@infradead.org>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>, kernel@savoirfairelinux.com
Message-ID: <810077082.264036.1421778036663.JavaMail.root@mail>
In-Reply-To: <CAHR064jkFMd3FWxGvOrE0FfXzLHoQSb9LU8Mi_AZk-CST01Sqw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] asus-laptop: cleanup is_visible
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corentin,

> > Use the attribute indexes and concise the if statements.
> >
> Why ? I really don't see that as an improvement.

The improvement is code clarity and maintainability. I'm not use we want
to keep multiple returns and this goto thing. I think per-attribute 
if-statements are clearer.

Thanks,
-v
