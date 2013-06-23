Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3FWLeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 07:34:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57413 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750953Ab3FWLeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 07:34:19 -0400
Message-ID: <1371987257.3137.44.camel@joe-AO722>
Subject: Re: [PATCHv v3] power: Include additional information in
 pm_print_times
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Shuah Khan <shuah.kh@samsung.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Date: Sun, 23 Jun 2013 04:34:17 -0700
In-Reply-To: <3043483.hQyzHovghE@vostro.rjw.lan>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com>
	 <2534796.mOHH0DCD2A@vostro.rjw.lan>
	 <B8EFE96D1287C24090BAD9D858E15E6172EFEE@sisaex02sj>
	 <3043483.hQyzHovghE@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-23 at 13:36 +0200, Rafael J. Wysocki wrote:
> Please keep the existing format as is literally and append any
> new information to the end of the line.

Hi Shuah.

Perhaps the better long-term approach would be to add
a new tracepoint too.


