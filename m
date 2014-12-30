Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaL3WKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:10:25 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:64701 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaL3WKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:10:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        cornelia.huck@de.ibm.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/7] pci: add pci_iomap_range
Date: Tue, 30 Dec 2014 23:10:14 +0100
Message-ID: <10386676.zGp2atn6SR@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1419957310-26009-3-git-send-email-mst@redhat.com>
References: <1419957310-26009-1-git-send-email-mst@redhat.com> <1419957310-26009-3-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Lcr90D1s+SahZtg4MgyoBJaMoNk8S6dNcnKcs+f2oYobdwAPbGd
 KWUx39jo5XIIY9NmM8+gYLzg7CEpoLMZ9+CYDZgpUyZaWGz6y+okNicvf/L3NbjfuohZ8In
 I3DzlK40d69jinX9BoHnj6Vy+d+gVED4GzfAW5Qb7feKNMtaW87VFnPnROTcz5DUzqWf8Y9
 th/e0Tk5NpTv7OY25zXQA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 December 2014 18:35:36 Michael S. Tsirkin wrote:
> From: Michael S Tsirkin <mst@redhat.com>
> 
> Virtio drivers should map the part of the BAR they need, not necessarily
> all of it.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Arnd Bergmann <arnd@arndb.de>
