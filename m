Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3ANDmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 22:42:33 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35459 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755219Ab3ANDmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 22:42:32 -0500
Message-ID: <1358134958.19400.9.camel@joe-AO722>
Subject: Re: [PATCH] scripts: checkpatch.pl: Fix misused memset detection
From: Joe Perches <joe@perches.com>
To: Cruz Julian Bishop <cruzjbishop@gmail.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Date: Sun, 13 Jan 2013 19:42:38 -0800
In-Reply-To: <1358132679-12235-1-git-send-email-cruzjbishop@gmail.com>
References: <1358132679-12235-1-git-send-email-cruzjbishop@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-14 at 13:04 +1000, Cruz Julian Bishop wrote:
> Previously, checking memset declarations would generate
> a lot of errors saying that $ms_size was not defined.

Try this one instead:

https://lkml.org/lkml/2013/1/10/444



