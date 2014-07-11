Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaGKJdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:33:21 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57684 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaGKJdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:33:20 -0400
From: Jassi Brar <jaswinder.singh@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ks.giri@samsung.com, arnd@arndb.de, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, pawel.moll@arm.com,
        courtney.cavin@sonymobile.com, mporter@linaro.org,
        slapdau@yahoo.com.au, lftan.linux@gmail.com, loic.pallardy@st.com,
        s-anna@ti.com, ashwin.chaugule@linaro.org, bjorn@kryo.se,
        patches@linaro.org, Mollie.Wu@tw.fujitsu.com,
        t.takinishi@jp.fujitsu.com
Subject: [PATCHv8 0/2] Common Mailbox Framework
Date: Fri, 11 Jul 2014 15:02:47 +0530
Message-Id: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  Here is the next revision of Mailbox framwork.

Changes since v7:
 o Added documentation and example usage.
 o Merged all patches into one that create api, bindings and
   documentation.

Changes since v6:
 o Separate out generic DT bindings patch.
 o Discard unnecessary aligned attributes.

Changes since v5:
 o Use standard error types instead of special type mbox_result.
 o Constify client struct in request_channel
 o Use reinit_completion instead of init_completion every time.
 o Improve commentary in bindings and code.

Changes since v4:
 o Common DT binding for Controller and Client drivers
    As a result, discard string based channel matching
 o Provide for an atomic 'peek' api, that a client could
    call to trigger the controller driver push data upwards.
 o OMAP and Highbank conversion to new api is left out, which
    can be converted later by the developers.

Changes since v3:
 o Change name of symbols from ipc to mbox
 o Return real types instead of void *
 o Align structures
 o Change some symbol names
	rxcb -> rx_callback
	txcb -> tx_done
 o Added kernel-doc for exported API
 o Dropped the cl_id and use clients pointer for callbacks.
 o Fixed locking of channel pool
 o Return negative error code for unsuccessful ipc_send_message()
 o Module referencing during mailbox assignment to a client.
 o Made error code symbols specific to mailbox.

Thanks
Jassi
