Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939Ab3BYWe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:34:57 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:57271 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759894Ab3BYWev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:34:51 -0500
Date: Mon, 25 Feb 2013 17:34:50 -0500 (EST)
From: Bob Peterson <rpeterso@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
        linux-kernel@vger.kernel.org
Message-ID: <2088991339.8695332.1361831690559.JavaMail.root@redhat.com>
In-Reply-To: <20130225221647.137610334@linuxfoundation.org>
Subject: Re: [ 51/58] GFS2: Get a block reservation before resizing a file
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.3.112.33]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
| 3.7-stable review patch.  If anyone has any objections, please let me
| know.
| 
| ------------------
| 
| From: Bob Peterson <rpeterso@redhat.com>
| 
| commit d2b47cfb26fe06002b8011707baac71a9ae8166f upstream.
| 
| This patch allocates a block reservation structure before growing
| or shrinking a file. Without this structure, the grow or shink code
| can reference the bad pointer.
| 
| Signed-off-by: Bob Peterson <rpeterso@redhat.com>
| Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
| Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Hi,

ACK

Bob Peterson
Red Hat File Systems
