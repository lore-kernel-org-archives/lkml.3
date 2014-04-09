Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750862AbaDIEU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 00:20:57 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:22522 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbaDIEU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 00:20:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEYAE/JRFNXQzmj/2dsb2JhbABZgwaCSYECE4o9tykCAgEBgRcXdIIlAQEBAwE6HCMFCwgDRjkeBhOHdAwByn4XjmwHhDgBA5hcAZJBgzI7
Date: Wed, 9 Apr 2014 06:22:45 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Wengang <wen.gang.wang@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/1] OCFS2: Remove NULL assignments on
 static
Message-Id: <20140409062245.3aafb6e5f5039380f8e4c757@skynet.be>
In-Reply-To: <534499FA.8010107@oracle.com>
References: <20140408221342.9759bea1dd852f2787f82586@skynet.be>
	<534499FA.8010107@oracle.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Apr 2014 08:53:14 +0800
Wengang <wen.gang.wang@oracle.com> wrote:

> Hi Fabian,
> 
> What's the badness if we do the assignments?
> 
> thanks,
> wengang

Hi Wengang,

	Nothing wrong but AFAICS redundant.

Regards,
Fabian

