Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaJQWoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 18:44:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:65341 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaJQWoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 18:44:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,742,1406617200"; 
   d="scan'208";a="607258530"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: Resolve some missing-field-initializers warnings
Thread-Topic: [PATCH] scsi: Resolve some missing-field-initializers warnings
Thread-Index: AQHP57Q4sZDfkQ9dA0OwSwU5MXkMjJw0wcWAgAAmrXk=
Date: Fri, 17 Oct 2014 22:44:36 +0000
Message-ID: <C69957AC-DB35-467C-85B1-091B740C74C9@intel.com>
References: <1413293933-31164-1-git-send-email-jeffrey.t.kirsher@intel.com>,<20141017132611.GM16538@infradead.org>
In-Reply-To: <20141017132611.GM16538@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warning appears in W=2 builds. I had another way to silence it by using diagnostic control macros, but those macros were not accepted. Using a single designated initialization also silences it.

Sent from my iPhone

> On Oct 17, 2014, at 8:26 AM, "Christoph Hellwig" <hch@infradead.org> wrote:
> 
>> On Tue, Oct 14, 2014 at 06:38:53AM -0700, Jeff Kirsher wrote:
>> From: Mark Rustad <mark.d.rustad@intel.com>
>> 
>> Resolve some missing-field-initializers warnings by using
>> designated initialization.
> 
> What tool is warning about these?  This construct is perfectly valid C.
