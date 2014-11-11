Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaKKDan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 22:30:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:49698 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKKDal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 22:30:41 -0500
X-AuditID: cbfee68d-f79296d000004278-40-546182d9c801
Message-id: <546182D9.7040107@samsung.com>
Date: Tue, 11 Nov 2014 12:30:33 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Avi Shchislowski <avi.shchislowski@sandisk.com>, ulf.hansson@linaro.org
Cc: "'Chris Ball'" <chris@printf.net>, linux-mmc@vger.kernel.org,
        Alex.Lemberg@sandisk.com, gwendal@google.com,
        open list <linux-kernel@vger.kernel.org>, CPGS <cpgs@samsung.com>
Subject: Re: [PATCH 2/3]  mmc: Support FFU for eMMC v5.0
References: <n@samsung.com>
 <1415639943-12068-1-git-send-email-avi.shchislowski@sandisk.com>
In-reply-to: <1415639943-12068-1-git-send-email-avi.shchislowski@sandisk.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWyRsSkSPdmU2KIwfkvxhY3H/xgs9i5dx2T
	xYTL2xktXh7StLi7cwKjxeVdc9gsjvzvZ7Q4vjbcgcNjwaZSjzvX9rB53Hi1kMmjb8sqRo9p
	a84zeXzeJBfAFsVlk5Kak1mWWqRvl8CVsX7GIeaC5Z4V61fsZ2xgbLXqYuTkkBAwkXjX9poF
	whaTuHBvPVsXIxeHkMBSRokl26YzwxSd+vOPHcQWEpjOKDH1pQFE0WtGiStLTgIVcXDwCmhJ
	XG7QBKlhEVCV6Px8B6yXTUBHYvu340wgtqhAmMShtnlgNq+AoMSPyffAFosIeEscOfWTHWQm
	s8BmRok97R/AmoUFLCQedrUwQSyOkzjwbx0riM0p4Ctx+8I/RhCbGWjB/tZpbBC2vMTmNW+Z
	QQZJCNxil1h0azErxEUCEt8mH2IBOVRCQFZi0wGoxyQlDq64wTKBUWwWkptmIRk7C8nYBYzM
	qxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzECo/D0v2e9OxhvH7A+xCjAwajEw6vpnxgixJpY
	VlyZe4jRFOiKicxSosn5wFjPK4k3NDYzsjA1MTU2Mrc0UxLnVZT6GSwkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qB8V7hw5merPuUPYWvuj2/K8LaKXbm6U2dqk6ON482bEzY6cgtL/dKz2EZ
	S6Fx0kSBp8cM5uZIls1ZIKiyKt+9IOXHrU1H78xYsr82RGpfpaL3Q72kdVmzZUrKEwurYvym
	5d5Ib3v69L3n1UkhcxeXz73meYel/eiqJ2Hc1Z6zVZaHJ7k/StyxS4mlOCPRUIu5qDgRAJ57
	WVO9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQd2bTYkhBhdma1rcfPCDzWLn3nVM
	FhMub2e0eHlI0+LuzgmMFpd3zWGzOPK/n9Hi+NpwBw6PBZtKPe5c28PmcePVQiaPvi2rGD2m
	rTnP5PF5k1wAW1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKL
	T4CuW2YO0DlKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoz1Mw4xFyz3
	rFi/Yj9jA2OrVRcjJ4eEgInEqT//2CFsMYkL99azgdhCAtMZJaa+NOhi5AKyXzNKXFlykrmL
	kYODV0BL4nKDJkgNi4CqROfnO8wgNpuAjsT2b8eZQGxRgTCJQ23zwGxeAUGJH5PvsYDYIgLe
	EkdO/WQHmckssJlRYk/7B7BmYQELiYddLUwQi+MkDvxbxwpicwr4Sty+8I8RxGYGWrC/dRob
	hC0vsXnNW+YJjAKzkOyYhaRsFpKyBYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY/yZ
	9A7GVQ0WhxgFOBiVeHg1/BNDhFgTy4orcw8xSnAwK4nw1icAhXhTEiurUovy44tKc1KLDzGa
	AoNgIrOUaHI+MP3klcQbGpuYGVkamRtaGBmbK4nzHmy1DhQSSE8sSc1OTS1ILYLpY+LglGpg
	lHt8TmRKR9hkxtC0fRfPfDF7tflX0d8it9OFe5oeNjCUVreL6bdfPm3ixWo0+3XJjXMFe+7v
	Lw2+f8tbPn9e+Ucx7Z2v/BrrKrmN+xikTp6eMEH3+BN3i4R2o/d3M5Y5ukr1TXu/4SjbGqHe
	75NuLc/xbszIKOa/+EzgcOmKxV4vU6rUZ7LmK7EUZyQaajEXFScCABF99eMHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/11/2014 02:18 AM, Avi Shchislowski wrote:
> eMMC5.0 FFU is using some of pre-existing mmc_test.c functionality.
> In order to prevent code duplication, some code of mmc_test.c was moved to core.c and modified.
> 
> Signed-off-by: Avi Shchislowski <avi.shchislowski@sandisk.com>
> Signed-off-by: Alex Lemberg <alex.lemberg@sandisk.com>
> 
> diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
> index 0c0fc52..e6ee0a8 100644
> --- a/drivers/mmc/card/mmc_test.c
> +++ b/drivers/mmc/card/mmc_test.c
> @@ -13,6 +13,7 @@
>  #include <linux/mmc/card.h>
>  #include <linux/mmc/host.h>
>  #include <linux/mmc/mmc.h>
> +#include <linux/mmc/core.h>
>  #include <linux/slab.h>
>  
>  #include <linux/scatterlist.h>
> @@ -189,43 +190,8 @@ static void mmc_test_prepare_mrq(struct mmc_test_card *test,
>  	struct mmc_request *mrq, struct scatterlist *sg, unsigned sg_len,
>  	unsigned dev_addr, unsigned blocks, unsigned blksz, int write)
>  {
> -	BUG_ON(!mrq || !mrq->cmd || !mrq->data || !mrq->stop);
> -
> -	if (blocks > 1) {
> -		mrq->cmd->opcode = write ?
> -			MMC_WRITE_MULTIPLE_BLOCK : MMC_READ_MULTIPLE_BLOCK;
> -	} else {
> -		mrq->cmd->opcode = write ?
> -			MMC_WRITE_BLOCK : MMC_READ_SINGLE_BLOCK;
> -	}
> -
> -	mrq->cmd->arg = dev_addr;
> -	if (!mmc_card_blockaddr(test->card))
> -		mrq->cmd->arg <<= 9;
> -
> -	mrq->cmd->flags = MMC_RSP_R1 | MMC_CMD_ADTC;
> -
> -	if (blocks == 1)
> -		mrq->stop = NULL;
> -	else {
> -		mrq->stop->opcode = MMC_STOP_TRANSMISSION;
> -		mrq->stop->arg = 0;
> -		mrq->stop->flags = MMC_RSP_R1B | MMC_CMD_AC;
> -	}
> -
> -	mrq->data->blksz = blksz;
> -	mrq->data->blocks = blocks;
> -	mrq->data->flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
> -	mrq->data->sg = sg;
> -	mrq->data->sg_len = sg_len;
> -
> -	mmc_set_data_timeout(mrq->data, test->card);
> -}
> -
> -static int mmc_test_busy(struct mmc_command *cmd)
> -{
> -	return !(cmd->resp[0] & R1_READY_FOR_DATA) ||
> -		(R1_CURRENT_STATE(cmd->resp[0]) == R1_STATE_PRG);
> +	mmc_prepare_mrq(test->card, mrq, sg, sg_len,
> +		dev_addr, blocks, blksz, write);
>  }
>  
>  /*
> @@ -233,30 +199,9 @@ static int mmc_test_busy(struct mmc_command *cmd)
>   */
>  static int mmc_test_wait_busy(struct mmc_test_card *test)
>  {
> -	int ret, busy;
> -	struct mmc_command cmd = {0};
> -
> -	busy = 0;
> -	do {
> -		memset(&cmd, 0, sizeof(struct mmc_command));
> -
> -		cmd.opcode = MMC_SEND_STATUS;
> -		cmd.arg = test->card->rca << 16;
> -		cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
> -
> -		ret = mmc_wait_for_cmd(test->card->host, &cmd, 0);
> -		if (ret)
> -			break;
> -
> -		if (!busy && mmc_test_busy(&cmd)) {
> -			busy = 1;
> -			if (test->card->host->caps & MMC_CAP_WAIT_WHILE_BUSY)
> -				pr_info("%s: Warning: Host did not "
> -					"wait for busy state to end.\n",
> -					mmc_hostname(test->card->host));
> -		}
> -	} while (mmc_test_busy(&cmd));
> +	int ret;
>  
> +	ret = mmc_wait_busy(test->card);

return mmc_wait_busy(test->card);

And mmc_test_wait_busy is wrapper function?
Why do you use the wrapper function?

>  	return ret;
>  }
>  
> @@ -693,19 +638,9 @@ static int mmc_test_check_result(struct mmc_test_card *test,
>  {
>  	int ret;
>  
> -	BUG_ON(!mrq || !mrq->cmd || !mrq->data);
> -
>  	ret = 0;
>  
> -	if (!ret && mrq->cmd->error)
> -		ret = mrq->cmd->error;
> -	if (!ret && mrq->data->error)
> -		ret = mrq->data->error;
> -	if (!ret && mrq->stop && mrq->stop->error)
> -		ret = mrq->stop->error;
> -	if (!ret && mrq->data->bytes_xfered !=
> -		mrq->data->blocks * mrq->data->blksz)
> -		ret = RESULT_FAIL;
> +	ret = mmc_check_result(mrq);
>  
>  	if (ret == -EINVAL)
>  		ret = RESULT_UNSUP_HOST;
> @@ -844,23 +779,13 @@ static int mmc_test_simple_transfer(struct mmc_test_card *test,
>  	struct scatterlist *sg, unsigned sg_len, unsigned dev_addr,
>  	unsigned blocks, unsigned blksz, int write)
>  {
> -	struct mmc_request mrq = {0};
> -	struct mmc_command cmd = {0};
> -	struct mmc_command stop = {0};
> -	struct mmc_data data = {0};
> -
> -	mrq.cmd = &cmd;
> -	mrq.data = &data;
> -	mrq.stop = &stop;
> +	int ret;
>  
> -	mmc_test_prepare_mrq(test, &mrq, sg, sg_len, dev_addr,
> +	ret = mmc_simple_transfer(test->card, sg, sg_len, dev_addr,
>  		blocks, blksz, write);
> -
> -	mmc_wait_for_req(test->card->host, &mrq);
> -
> -	mmc_test_wait_busy(test);
> -
> -	return mmc_test_check_result(test, &mrq);
> +	if (ret == -EINVAL)
> +		ret = RESULT_UNSUP_HOST;
> +	return ret;
>  }
>  
>  /*
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index d03a080..132da0c 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -2658,6 +2658,134 @@ int mmc_pm_notify(struct notifier_block *notify_block,
>  	return 0;
>  }
>  #endif
> +/*
> + * Fill in the mmc_request structure given a set of transfer parameters.
> + */
> +void mmc_prepare_mrq(struct mmc_card *card,
> +	struct mmc_request *mrq, struct scatterlist *sg, unsigned sg_len,
> +	unsigned dev_addr, unsigned blocks, unsigned blksz, int write)
> +{
> +	BUG_ON(!mrq || !mrq->cmd || !mrq->data || !mrq->stop);
> +
> +	if (blocks > 1) {
> +		mrq->cmd->opcode = write ?
> +			MMC_WRITE_MULTIPLE_BLOCK : MMC_READ_MULTIPLE_BLOCK;
> +	} else {
> +		mrq->cmd->opcode = write ?
> +			MMC_WRITE_BLOCK : MMC_READ_SINGLE_BLOCK;
> +	}
> +
> +	mrq->cmd->arg = dev_addr;
> +	if (!mmc_card_blockaddr(card))
> +		mrq->cmd->arg <<= 9;
> +
> +	mrq->cmd->flags = MMC_RSP_R1 | MMC_CMD_ADTC;
> +
> +	if (blocks == 1)
> +		mrq->stop = NULL;
> +	else {
> +		mrq->stop->opcode = MMC_STOP_TRANSMISSION;
> +		mrq->stop->arg = 0;
> +		mrq->stop->flags = MMC_RSP_R1B | MMC_CMD_AC;
> +	}
> +
> +	mrq->data->blksz = blksz;
> +	mrq->data->blocks = blocks;
> +	mrq->data->flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
> +	mrq->data->sg = sg;
> +	mrq->data->sg_len = sg_len;
> +
> +	mmc_set_data_timeout(mrq->data, card);
> +}
> +EXPORT_SYMBOL(mmc_prepare_mrq);
> +
> +static int mmc_busy(struct mmc_command *cmd)
> +{
> +	return !(cmd->resp[0] & R1_READY_FOR_DATA) ||
> +		(R1_CURRENT_STATE(cmd->resp[0]) == R1_STATE_PRG);
> +}

What's function?

> +
> +/*
> + * Wait for the card to finish the busy state
> + */
> +int mmc_wait_busy(struct mmc_card *card)
> +{
> +	int ret, busy = 0;
> +	struct mmc_command cmd = {0};
> +
> +	memset(&cmd, 0, sizeof(struct mmc_command));
> +	cmd.opcode = MMC_SEND_STATUS;
> +	cmd.arg = card->rca << 16;
> +	cmd.flags = MMC_RSP_SPI_R2 | MMC_RSP_R1 | MMC_CMD_AC;
> +
> +	do {
> +		ret = mmc_wait_for_cmd(card->host, &cmd, 0);
> +		if (ret)
> +			break;
> +
> +		if (!busy && mmc_busy(&cmd)) {
> +			busy = 1;
> +			if (card->host->caps & MMC_CAP_WAIT_WHILE_BUSY) {
> +				pr_warn("%s: Warning: Host did not "
> +					"wait for busy state to end.\n",
> +					mmc_hostname(card->host));
> +			}
> +		}
> +
> +	} while (mmc_busy(&cmd));
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(mmc_wait_busy);
> +
> +int mmc_check_result(struct mmc_request *mrq)
> +{
> +	int ret;
> +
> +	BUG_ON(!mrq || !mrq->cmd || !mrq->data);
> +
> +	ret = 0;

Why do you initialized at here? 
if ret is 0, why do you check "if (!ret && xxxx)" at the below condition?

> +
> +	if (!ret && mrq->cmd->error)
> +		ret = mrq->cmd->error;
> +	if (!ret && mrq->data->error)
> +		ret = mrq->data->error;
> +	if (!ret && mrq->stop && mrq->stop->error)
> +		ret = mrq->stop->error;
> +	if (!ret && mrq->data->bytes_xfered !=
> +		mrq->data->blocks * mrq->data->blksz)
> +		ret = -EPERM;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(mmc_check_result);
> +
> +/*
> ++ * transfer with certain parameters
> + */
> +int mmc_simple_transfer(struct mmc_card *card,
> +	struct scatterlist *sg, unsigned sg_len, unsigned dev_addr,
> +	unsigned blocks, unsigned blksz, int write)
> +{
> +	struct mmc_request mrq = {0};
> +	struct mmc_command cmd = {0};
> +	struct mmc_command stop = {0};
> +	struct mmc_data data = {0};
> +
> +	mrq.cmd = &cmd;
> +	mrq.data = &data;
> +	mrq.stop = &stop;
> +
> +	mmc_prepare_mrq(card, &mrq, sg, sg_len, dev_addr,
> +		blocks, blksz, write);
> +
> +	mmc_wait_for_req(card->host, &mrq);
> +
> +	mmc_wait_busy(card);
> +
> +	return mmc_check_result(&mrq);
> +}
> +EXPORT_SYMBOL(mmc_simple_transfer);
>  
>  /**
>   * mmc_init_context_info() - init synchronization context
> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
> index f206e29..92540d0 100644
> --- a/include/linux/mmc/core.h
> +++ b/include/linux/mmc/core.h
> @@ -196,6 +196,14 @@ extern void mmc_put_card(struct mmc_card *card);
>  extern int mmc_flush_cache(struct mmc_card *);
>  
>  extern int mmc_detect_card_removed(struct mmc_host *host);
> +extern void mmc_prepare_mrq(struct mmc_card *card,
> +	struct mmc_request *mrq, struct scatterlist *sg, unsigned sg_len,
> +	unsigned dev_addr, unsigned blocks, unsigned blksz, int write);
> +extern int mmc_wait_busy(struct mmc_card *card);
> +extern int mmc_check_result(struct mmc_request *mrq);
> +extern int mmc_simple_transfer(struct mmc_card *card,
> +	struct scatterlist *sg, unsigned sg_len, unsigned dev_addr,
> +	unsigned blocks, unsigned blksz, int write);
>  
>  /**
>   *	mmc_claim_host - exclusively claim a host
> 

