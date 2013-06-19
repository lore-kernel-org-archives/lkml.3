Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965060Ab3FSSqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:46:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:43837 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965004Ab3FSSqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:46:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,899,1363158000"; 
   d="scan'208";a="319582728"
From: "Luck, Tony" <tony.luck@intel.com>
To: Michael Neuling <mikey@neuling.org>,
        Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "ccross@android.com" <ccross@android.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "anton@samba.org" <anton@samba.org>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>
Subject: RE: [PATCH v4 0/8] Nvram-to-pstore
Thread-Topic: [PATCH v4 0/8] Nvram-to-pstore
Thread-Index: AQHOYh2tPzMOSeP5DUubcpE5iE3W8pk9GcmAgAAFSwCAAAE9AIAAVT+A
Date: Wed, 19 Jun 2013 18:46:45 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA88179@ORSMSX106.amr.corp.intel.com>
References: <20130605184756.25794.43872.stgit@aruna-ThinkPad-T420>
 <1822.1371622503@ale.ozlabs.ibm.com> <51C150D8.2070706@linux.vnet.ibm.com>
 <5493.1371623906@ale.ozlabs.ibm.com>
In-Reply-To: <5493.1371623906@ale.ozlabs.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You need to mount pstore to access the files.
> 
> # mkdir /dev/pstore
> # mount -t pstore - /dev/pstore
> 
> to unmount
> 
> # umount /dev/pstore
> 
> References: http://lwn.net/Articles/421297/

Note that /dev/pstore has fallen out of fashion as the mount point ... we now (since 3.9)
suggest /sys/fs/pstore

> Documentation/ABI/testing/pstore

This file was updated with the new location.

-Tony
 
