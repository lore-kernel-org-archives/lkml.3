Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422732Ab3BGW05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:26:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3BGW0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:26:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [char-misc-next 08/11] mei: nfc: Initial nfc implementation
Date: Thu, 7 Feb 2013 22:26:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com> <1360270997-7639-9-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1360270997-7639-9-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072226.42375.arnd@arndb.de>
X-Provags-ID: V02:K0:UxDOSwSPh/KbXBrl2YcTEcJ3aBf6b6T8EoOyhQyUWmI
 TX+VOOXd5ZCfFQQXouCDz8la9v/jiUdaBy8X4PnmNqnfkhmud6
 ZKdTqPWcR6wGTrr1UaLSzHHN56Zm+JPibizXODu1LEiZzj9AmH
 CQSbbIkGpVVm6vjQ0SnJVJeHWf185LYwO6/N+P2LLdjmQQGDSd
 2U1xt8u2bEgw+VmBJd18DkfbxPjWSXiPBy7dvF7iJN2yuj3jP/
 sdImOfQ2YtslWubE/+X432u8u5WiDIc8389antDV374nMbSI6H
 +Z7qDCKgmBHJ/bP2fomIUPnYF/JrYTjTWLfLplGKBn2MAP6s2i
 6D6PIw66wlsdL8vJvGE4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Tomas Winkler wrote:
> 
> From: Samuel Ortiz <sameo@linux.intel.com>
> 
> NFC ME client is exported through mei bus to be consumed by the
> NFC subsystem.
> 
> NFC is represented by two mei clients: An info one and the actual
> NFC one. In order for correct connection we first need to retrieve the
> firmware information from the info client.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Shouldn't this be moved to the drivers/nfc directory? Generally speaking,
all drivers nowadays tend to live in the directories of the subsystems
they are implementing support for, not the subsystems that they are
implemented with.

	Arnd
