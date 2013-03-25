Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab3CYNxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:53:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59976 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab3CYNxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:53:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCHv2 3/3] serial: of_serial: Handle auto-flow-control property
Date: Mon, 25 Mar 2013 13:53:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ley Foon Tan <lftan@altera.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <20130325131727.GB2847@xps8300> <1364219475-18215-1-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1364219475-18215-1-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251353.41501.arnd@arndb.de>
X-Provags-ID: V02:K0:IJexEmXOLhsJpiJDlzGHrSeVcUW3CcT4/e5Io8L1v36
 +bZi8H432+qgVo4fmolh9NdIo5vHbhv+50NuVKkccMTlem7JJh
 Fhd6jfK1BPW44NgmK56va0cL5bq4/W7P3rob7m3cm/IfItpS9H
 gCE01CpKgS20DmazrgmVyy3AQLF2ztQGHjhu6i1r54O5fgnl2h
 gTQG8zJ1SQUUKGBCMkQ5uwxkzBALfzND5FslbggwtwXgFWClrA
 xj5ClBwnrxKgiQnj3X3l8K+NJcw5PUwVK0DIH6EmvRhpV2Lb/l
 RmoiUeqh9JztrGMRpcSi7JH/iebqkVb/WkT1/X3vywU6uvgP1A
 K6HypI5sji44Y7tRLyr4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013, Heikki Krogerus wrote:
> 
> Automatic Flow Control capability is not tied to this
> property. This is only one way of detecting it. The property
> is limited to be used only with 8250 driver.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
