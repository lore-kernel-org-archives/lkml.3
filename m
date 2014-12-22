Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaLVCkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:40:06 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:43542 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaLVCkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:40:05 -0500
Date: Sun, 21 Dec 2014 18:39:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: Jeremiah Mahler <jmmahler@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>, David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v16 00/12] input: cyapa: instruction of cyapa patches
Message-ID: <20141222023959.GA30082@dtor-ws>
References: <1418896856-15766-1-git-send-email-dudl@cypress.com>
 <20141220071533.GA1139@newt.localdomain>
 <20141220073154.GB4637@dtor-ws>
 <BN1PR06MB0701C428956C2E7F7A1DD76D1560@BN1PR06MB070.namprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN1PR06MB0701C428956C2E7F7A1DD76D1560@BN1PR06MB070.namprd06.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dudley,

On Mon, Dec 22, 2014 at 02:09:36AM +0000, Dudley Du wrote:
> Thanks, Dmitry and Jeremiah,
> 
> I reproduced this issue in my side when putting fingers on trackpad when system booting up.
> It only happened on gen3 trackpad device.
> The root cause is, for gen3 TP, the cyapa->ops->sort_empty_output_data is not set, so when cyapa->input is not set,
> the interrupt process should be passed, but since the logica error, it's not, so this issue happen.
> 
> The fix code should be as below.
> I will correct it and resubmited the patches.

Please hold off resubmitting the patches just yet, let me go over the
last version you posted.

Thanks!


-- 
Dmitry
