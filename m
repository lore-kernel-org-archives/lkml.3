Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3HZI6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:58:03 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:50442 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab3HZI6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:58:00 -0400
Message-ID: <1377507467.13247.3.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH v2] iwlwifi: mvm: make debugfs write() operations write
 up to count bytes
From: Johannes Berg <johannes@sipsolutions.net>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Aug 2013 10:57:47 +0200
In-Reply-To: <1377351353-18588-1-git-send-email-tixxdz@opendz.org> (sfid-20130824_153759_866417_83543693)
References: <1377351353-18588-1-git-send-email-tixxdz@opendz.org>
	 (sfid-20130824_153759_866417_83543693)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-24 at 14:35 +0100, Djalal Harouni wrote:
> Some debugfs write() operations of the MVM Firmware will ignore the
> count argument, and will copy more bytes than what was specified.
> Fix this by getting the right count of bytes.
> 
> This will honor restrictions put on the number of bytes to write and
> avoid strcmp() calls on garbage data.

Applied, thanks.

johannes

