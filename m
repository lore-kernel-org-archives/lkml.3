Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3KUJPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:15:55 -0500
Received: from queue01a.mail.zen.net.uk ([212.23.3.234]:40706 "EHLO
	queue01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3KUJPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:15:52 -0500
X-Greylist: delayed 1176 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2013 04:15:52 EST
Message-ID: <1385023993.3524.15.camel@linaro1.home>
Subject: Re: [GIT PULL] direct IO support for loop driver
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 21 Nov 2013 08:53:13 +0000
In-Reply-To: <CA+55aFwgGg2yzoUukVuAz2Feo4kU4=8CNBGY7phUHGSBDt8xwA@mail.gmail.com>
References: <528A648F.1030007@oracle.com>
	 <CA+55aFyF-Za7B=1kVDodbn942hETsWixAHCsh_wBA1b6pnUigQ@mail.gmail.com>
	 <CA+55aFwgGg2yzoUukVuAz2Feo4kU4=8CNBGY7phUHGSBDt8xwA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-20 at 13:38 -0800, Linus Torvalds wrote:
[...]
> And no, you don't then
> make it do *both* the conditional *and* the function pointer like you
> did in that discusting commit that mixes the two with the struct

discusting, adjective
1. Something unpleasant that causes people to cuss.
2. Something unpleasant that provokes a discussion.

Sorry, couldn't resist :-)

-- 
Tixy


