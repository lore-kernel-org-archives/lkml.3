Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab3GOV6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:58:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45821 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab3GOV6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:58:23 -0400
Message-ID: <51E47051.7030608@zytor.com>
Date: Mon, 15 Jul 2013 14:57:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: update git pull info in SubmittingPatches
References: <1373923096-25674-1-git-send-email-paul.gortmaker@windriver.com> <51E46A4D.6060108@infradead.org> <51E46C3B.5020104@windriver.com> <51E46E55.7090909@infradead.org>
In-Reply-To: <51E46E55.7090909@infradead.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something else to put in there: if someone absolutely feels the need to
put cover text before the patch, it should be separated from the patch
proper by a scissor line (---8<---) or there is no support for
automating the patch.

	-hpa

